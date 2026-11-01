#!/usr/bin/env python3
"""Portable local chat gateway. Uses only Python's standard library."""
from http.server import ThreadingHTTPServer, BaseHTTPRequestHandler
from pathlib import Path
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError
from urllib.parse import urlparse
import json, os, platform, shutil, socket, threading, time, webbrowser

ROOT = Path(__file__).resolve().parent
DATA = ROOT / 'chat_data'
DATA.mkdir(exist_ok=True)
PORT = int(os.environ.get('PORTLLM_PORT', '3333'))
ENGINE = os.environ.get('PORTLLM_ENGINE', 'ollama')
ENGINE_URL = os.environ.get('PORTLLM_ENGINE_URL', 'http://127.0.0.1:11434' if ENGINE == 'ollama' else 'http://127.0.0.1:8080')
LOCK = threading.Lock()

def read_json(path, fallback):
    try: return json.loads(path.read_text(encoding='utf-8'))
    except (OSError, ValueError): return fallback

def write_json(path, value):
    with LOCK:
        tmp = path.with_suffix(path.suffix + '.tmp')
        tmp.write_text(json.dumps(value, ensure_ascii=False, indent=2), encoding='utf-8')
        tmp.replace(path)

class Handler(BaseHTTPRequestHandler):
    server_version = 'PortLLM/1.0'
    def log_message(self, fmt, *args): print('%s %s' % (self.log_date_time_string(), fmt % args))
    def reply(self, status, value, content_type='application/json; charset=utf-8'):
        body = value if isinstance(value, bytes) else (json.dumps(value).encode() if content_type.startswith('application/json') else str(value).encode())
        self.send_response(status); self.send_header('Content-Type', content_type); self.send_header('Content-Length', str(len(body))); self.send_header('Cache-Control','no-store'); self.end_headers(); self.wfile.write(body)
    def body(self):
        n = min(int(self.headers.get('Content-Length','0')), 4_000_000)
        try: return json.loads(self.rfile.read(n) or b'{}')
        except ValueError: return {}
    def do_GET(self):
        path = urlparse(self.path).path
        if path == '/api/chats': return self.reply(200, read_json(DATA/'chats.json', []))
        if path == '/api/settings': return self.reply(200, read_json(DATA/'settings.json', {'globalSystemPrompt':'','temperature':0.7}))
        if path == '/api/stats':
            mem = shutil.disk_usage(ROOT)
            return self.reply(200, {'platform': platform.platform(), 'cpu_count': os.cpu_count(), 'disk_free_gb': round(mem.free/1024**3,1), 'engine': ENGINE, 'engine_url': ENGINE_URL})
        if path.startswith('/api/engine/'):
            engine_path = path.removeprefix('/api/engine')
            if ENGINE == 'llama' and engine_path == '/api/tags': engine_path = '/v1/models'
            return self.proxy('GET', engine_path)
        if path in ('/', '/index.html'): return self.reply(200, (ROOT/'PortLLM_UI.html').read_bytes(), 'text/html; charset=utf-8')
        target = (ROOT / path.lstrip('/')).resolve()
        if ROOT not in target.parents or not target.is_file(): return self.reply(404, {'error':'Not found'})
        return self.reply(200, target.read_bytes(), 'application/octet-stream')
    def do_POST(self):
        path, data = urlparse(self.path).path, self.body()
        if path == '/api/chats':
            rows = read_json(DATA/'chats.json', [])
            if not isinstance(rows, list): rows=[]
            row = data if isinstance(data, dict) else {}
            row.setdefault('id', str(int(time.time()*1000))); row.setdefault('updatedAt', int(time.time()*1000))
            rows = [x for x in rows if x.get('id') != row['id']]; rows.insert(0,row)
            write_json(DATA/'chats.json', rows[:500]); return self.reply(200, {'ok':True,'chat':row})
        if path == '/api/settings':
            write_json(DATA/'settings.json', data); return self.reply(200, {'ok':True})
        if path.startswith('/api/engine/'):
            return self.proxy('POST', path.removeprefix('/api/engine'), json.dumps(data).encode())
        return self.reply(404, {'error':'Not found'})
    def do_DELETE(self):
        path = urlparse(self.path).path
        if path.startswith('/api/chats/'):
            ident = path.rsplit('/',1)[-1]
            rows = read_json(DATA/'chats.json', [])
            write_json(DATA/'chats.json', [x for x in rows if str(x.get('id')) != ident])
            return self.reply(200, {'ok':True})
        return self.reply(404, {'error':'Not found'})
    def proxy(self, method, path, payload=None):
        try:
            llama_chat = ENGINE == 'llama' and method == 'POST' and path == '/api/chat'
            if llama_chat:
                incoming = json.loads(payload or b'{}')
                payload = json.dumps({'model': incoming.get('model') or 'local', 'messages': incoming.get('messages', []), 'stream': False}).encode()
                path = '/v1/chat/completions'
            req = Request(ENGINE_URL + path, data=payload, method=method, headers={'Content-Type':'application/json'})
            with urlopen(req, timeout=900) as response:
                raw=response.read()
                if ENGINE == 'llama' and method == 'GET' and path == '/v1/models':
                    models=json.loads(raw).get('data',[]); raw=json.dumps({'models':[{'name':m.get('id','local')} for m in models]}).encode()
                elif llama_chat:
                    content=json.loads(raw).get('choices',[{}])[0].get('message',{}).get('content','')
                    raw=json.dumps({'message':{'content':content}}).encode()
                self.send_response(response.status); self.send_header('Content-Type','application/json; charset=utf-8'); self.send_header('Content-Length',str(len(raw))); self.end_headers(); self.wfile.write(raw)
        except HTTPError as e: self.reply(e.code, {'error':str(e)})
        except (URLError, TimeoutError, OSError) as e: self.reply(502, {'error':f'Inference engine unavailable: {e}'})

def main():
    server = ThreadingHTTPServer(('127.0.0.1', PORT), Handler)
    print(f'PortLLM ready at http://localhost:{PORT} (engine: {ENGINE_URL})')
    if os.environ.get('PORTLLM_NO_BROWSER') != '1':
        threading.Timer(1.0, lambda: webbrowser.open(f'http://localhost:{PORT}')).start()
    try: server.serve_forever()
    except KeyboardInterrupt: pass
    finally: server.server_close()
if __name__ == '__main__': main()

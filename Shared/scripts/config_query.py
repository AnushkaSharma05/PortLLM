#!/usr/bin/env python3
"""Read PortLLM JSON configuration in shell-friendly form."""
import json, shlex, sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
def main():
    if len(sys.argv)<2: print('Usage: config_query.py models-shell <desktop|android>',file=sys.stderr); return 2
    try: data=json.loads((ROOT/'config/models.json').read_text(encoding='utf-8'))
    except (OSError,ValueError) as exc: print(exc,file=sys.stderr); return 1
    if sys.argv[1]=='models-shell' and len(sys.argv)>2:
        key='desktop_models' if sys.argv[2]=='desktop' else 'android_models'
        for idx,item in enumerate(data.get(key,[]),1): print(f"MODEL_{idx}={shlex.quote(item.get('name',''))}|{shlex.quote(item.get('url',''))}")
        return 0
    print('Unknown command',file=sys.stderr); return 2
if __name__=='__main__': raise SystemExit(main())

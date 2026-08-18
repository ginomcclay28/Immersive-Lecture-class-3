"""Tiny static server for the lecture deck — same as python -m http.server,
but tells the browser never to cache. Without this, editing index.html and
refreshing can still show the old slide deck.

Usage: python serve.py [port]
"""
import sys
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer


class NoCacheHandler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0")
        self.send_header("Pragma", "no-cache")
        self.send_header("Expires", "0")
        super().end_headers()

    def log_message(self, fmt, *args):        # keep the console quiet
        pass


if __name__ == "__main__":
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8777
    handler = partial(NoCacheHandler, directory=".")
    print("Serving this folder on http://localhost:%d  (no cache)" % port)
    print("Press Ctrl+C or close this window to stop.")
    try:
        ThreadingHTTPServer(("127.0.0.1", port), handler).serve_forever()
    except KeyboardInterrupt:
        pass

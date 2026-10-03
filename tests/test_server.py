import json
import threading
import urllib.error
import urllib.request
from http.server import ThreadingHTTPServer

from app.server import Handler


def test_release_and_unknown_path():
    server = ThreadingHTTPServer(("127.0.0.1", 0), Handler)
    thread = threading.Thread(target=server.serve_forever, daemon=True)
    thread.start()
    base = f"http://127.0.0.1:{server.server_port}"
    try:
        with urllib.request.urlopen(base + "/release") as response:
            assert json.load(response)["environment"] == "dev"
        try:
            urllib.request.urlopen(base + "/missing")
        except urllib.error.HTTPError as error:
            assert error.code == 404
        else:
            raise AssertionError("Expected 404")
    finally:
        server.shutdown()
        server.server_close()
        thread.join()

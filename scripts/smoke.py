#!/usr/bin/env python3
import json
import os
import sys
import time
import urllib.request

base = sys.argv[1] if len(sys.argv) > 1 else "http://127.0.0.1:8081"
for attempt in range(30):
    try:
        with urllib.request.urlopen(base + "/health", timeout=2) as response:
            result = json.load(response)
            assert result["status"] == "ok"
            expected = os.getenv("EXPECTED_RELEASE")
            if expected:
                assert result["release"] == expected, "Unexpected release identity"
        print(json.dumps(result))
        break
    except (OSError, AssertionError):
        if attempt == 29:
            raise
        time.sleep(1)

#!/usr/bin/env bash
source qapi_env/bin/activate
uvicorn app.main:app --reload --host 127.0.0.1 --port 8000

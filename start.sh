#!/usr/bin/env bash
source qapi_env/bin/activate
uvicorn app.main:app --host 0.0.0.0 --port 8000

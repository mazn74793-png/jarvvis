# https://github.com/bnsware
from __future__ import annotations

import json
from pathlib import Path


BASE_DIR = Path(__file__).resolve().parent
CONFIG_DIR = BASE_DIR / "config"
CONFIG_PATH = CONFIG_DIR / "api_keys.json"


DEFAULT_CONFIG = {
    "gemini_api_key": "",
    "voice": "Charon",
    "youtube_api_key": "",
    "youtube_channel_handle": "",
    # Yerel mod ayarlari
    "backend": "gemini",  # "gemini" veya "lmstudio"
    "lmstudio_base_url": "http://127.0.0.1:1234/v1",
    "lmstudio_model": "local-model",
    "lmstudio_vision_model": "",  # bos ise lmstudio_model kullanilir
    "lmstudio_api_key": "lm-studio",
    "stt_engine": "whisper",  # "whisper" | "google"
    "stt_language": "tr-TR",
}


def load_app_config() -> dict:
    config = dict(DEFAULT_CONFIG)
    try:
        raw = json.loads(CONFIG_PATH.read_text(encoding="utf-8"))
        if isinstance(raw, dict):
            config.update(raw)
    except Exception:
        pass
    return config


def save_app_config(updates: dict) -> dict:
    config = load_app_config()
    for key, value in (updates or {}).items():
        if value is None:
            continue
        config[key] = value
    CONFIG_DIR.mkdir(parents=True, exist_ok=True)
    CONFIG_PATH.write_text(
        json.dumps(config, indent=4, ensure_ascii=False),
        encoding="utf-8",
    )
    return config


def get_app_config_value(key: str, default=None):
    return load_app_config().get(key, default)


def has_gemini_api_key() -> bool:
    value = str(get_app_config_value("gemini_api_key", "") or "").strip()
    return bool(value)


def get_backend() -> str:
    backend = str(get_app_config_value("backend", "gemini") or "gemini").strip().lower()
    return backend if backend in {"gemini", "lmstudio"} else "gemini"


def is_local_backend() -> bool:
    return get_backend() == "lmstudio"


def has_runtime_credentials() -> bool:
    """JARVIS calistirilabilir mi? Yerel modda her zaman True."""
    if is_local_backend():
        return True
    return has_gemini_api_key()

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.openapi.utils import get_openapi
from fastapi.staticfiles import StaticFiles

import config

from api.v1.auth import router as auth_router
from api.v1.transactions import router as transactions_router
from api.v1.accounts import router as accounts_router
from api.v1.categories import router as categories_router
from services.reconcile_service import reconcile_account_balances
from database import get_session
import asyncio

app = FastAPI(
    title="Personal Budget API",
    description="API для приложения личного бюджета (FastAPI, PostgreSQL, Redis)",
    version="1.0.0"
)

# Serve static files such as uploaded profile images
app.mount(
    "/assets",
    StaticFiles(directory=config.BASE_DIR / "mobile_frontend" / "assets"),
    name="assets",
)

def custom_openapi():
    if app.openapi_schema:
        return app.openapi_schema
    openapi_schema = get_openapi(
        title="Finance Tracker API",
        version="1.0.0",
        description="API for managing finances",
        routes=app.routes,
    )
    openapi_schema["servers"] = [{"url": "http://127.0.0.1:8000"}]
    app.openapi_schema = openapi_schema
    return app.openapi_schema

app.openapi = custom_openapi

# (Опционально) Настройка CORS, если требуется доступ с фронтенда
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Register routers
app.include_router(auth_router)
app.include_router(transactions_router)
app.include_router(accounts_router)
app.include_router(categories_router)



# Теперь при запуске uvicorn main:app приложение запустится на указанном хосте:порт,
# а документация будет доступна по /docs (Swagger UI) и /redoc (ReDoc).

@app.on_event("startup")
async def run_reconcile_on_startup():
    # Best-effort invariant check; ignores errors to not block startup
    try:
        async for session in get_session():
            await reconcile_account_balances(session)
            break
    except Exception:
        pass

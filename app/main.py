from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.openapi.utils import get_openapi

from api.v1.auth import router as auth_router

app = FastAPI(
    title="Personal Budget API",
    description="API для приложения личного бюджета (FastAPI, PostgreSQL, Redis)",
    version="1.0.0"
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



# Теперь при запуске uvicorn main:app приложение запустится на указанном хосте:порт,
# а документация будет доступна по /docs (Swagger UI) и /redoc (ReDoc).

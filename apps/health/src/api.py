from fastapi import APIRouter

from controllers.health_check_controller import router as health_check_api

router = APIRouter()

router.include_router(health_check_api, prefix='/check', tags=['health-check'])

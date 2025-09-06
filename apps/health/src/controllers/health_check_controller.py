from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from starlette.responses import JSONResponse

from checks.postgres import check_postgres_health, get_postgres_session
from models.health_check_response import HealthCheckResponse, ServiceStatusType

router = APIRouter(
    prefix='/check',
    tags=['health-check'],
    redirect_slashes=False)


@router.get("/", status_code=status.HTTP_200_OK, response_model=HealthCheckResponse, responses={503: {"model": HealthCheckResponse}})
def health_check(session: Session = Depends(get_postgres_session)):
    is_postgres_up, error = check_postgres_health(session)
    status_code = status.HTTP_200_OK 
    if not is_postgres_up or error:
        status_code = status.HTTP_503_SERVICE_UNAVAILABLE
    
    health = is_postgres_up
    response = HealthCheckResponse(success=health, up=ServiceStatusType(postgres=is_postgres_up))
    return JSONResponse(content=response.model_dump(), status_code=status_code)


@router.get("/postgres/", status_code=status.HTTP_200_OK, response_model=HealthCheckResponse, responses={503: {"model": HealthCheckResponse}})
def postgres_health_check(session: Session = Depends(get_postgres_session)):
    is_postgres_up, error = check_postgres_health(session)
    status_code = status.HTTP_200_OK 
    if not is_postgres_up or error:
        status_code = status.HTTP_503_SERVICE_UNAVAILABLE
    
    health = is_postgres_up
    response = HealthCheckResponse(success=health, up=ServiceStatusType(postgres=is_postgres_up))
    return JSONResponse(content=response.model_dump(), status_code=status_code)

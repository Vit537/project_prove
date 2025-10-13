
from django.urls import path
from . import views

urlpatterns = [
    # GET/POST - Listar y crear personas
    path('person/', views.person_view, name='person_view'),
]



from django.urls import path
from . import views

urlpatterns = [
        # GET - Listar todas las personas
    path('person/', views.list_people, name='list_people'),
    # POST - Crear nueva persona
    path('person/create/', views.create_person, name='create_person'),

]


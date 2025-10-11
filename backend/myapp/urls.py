
from django.urls import path
from . import views

urlpatterns = [
    path('person/', views.create_person, name='create_person'),

]


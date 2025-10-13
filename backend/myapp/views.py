from django.shortcuts import render

# Create your views here.


from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from .models import Person
from .serializers import PersonSerializer

@api_view(['GET'])
def list_people(request):
    people = Person.objects.all()
    serializer = PersonSerializer(people, many=True)
    return Response(serializer.data)    

@api_view(['POST'])
def create_person(request):
    serializer = PersonSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
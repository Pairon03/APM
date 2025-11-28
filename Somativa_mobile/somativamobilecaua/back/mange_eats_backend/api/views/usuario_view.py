# api/views/user_view.py
from rest_framework import viewsets
from rest_framework.permissions import AllowAny
from rest_framework.decorators import action
from rest_framework.response import Response
from django.contrib.auth import authenticate
from django.contrib.auth.models import User
from api.serializers import UsuarioSerializer
from django.views.decorators.csrf import csrf_exempt

class UsuarioViewSet(viewsets.ModelViewSet):
    # Endpoint para Cadastro (POST) e Listagem (GET) de usuários
    queryset = User.objects.all()
    serializer_class = UsuarioSerializer
    permission_classes = [AllowAny] # Permite acesso sem token (para login/cadastro)

    @action(detail=False, methods=['post'])
    def login(self, request):
        """ Endpoint customizado para o login do usuário. """
        username = request.data.get('username')
        password = request.data.get('password')
        

        
        # Usando 'username' e 'password' para autenticação
        if username is None or password is None:
             return Response({'status': 'error', 'message': 'Campos username e password são obrigatórios.'}, status=400)

        user = authenticate(username=username, password=password)
        
        if user is not None:
            return Response({'status': 'success', 'user_id': user.id, 'message': 'Login realizado com sucesso.'})
        else:
            return Response({'status': 'error', 'message': 'Credenciais inválidas.'}, status=401)
# api/serializers/user_serializer.py

from rest_framework import serializers
from django.contrib.auth.models import User

class UsuarioSerializer(serializers.ModelSerializer):
    # Campos para validação de confirmação de senha (não são campos do model)
    password_confirm = serializers.CharField(style={'input_type': 'password'}, write_only=True)

    class Meta:
        model = User
        # Adicionamos 'email'
        fields = ['id', 'username', 'email', 'password', 'password_confirm']
        extra_kwargs = {
            'password': {'write_only': True, 'required': True, 'style': {'input_type': 'password'}},
            'email': {'required': True}, # Tornar o email obrigatório
        }
    
    # 🚨 Implementação da validação de confirmação de senha
    def validate(self, data):
        if data['password'] != data['password_confirm']:
            raise serializers.ValidationError({"password_confirm": "As senhas não coincidem."})
        return data

    def create(self, validated_data):
        # Removemos 'password_confirm' antes de criar o usuário
        validated_data.pop('password_confirm', None)
        
        # O Django cria o usuário e hash a senha
        user = User.objects.create_user(**validated_data)
        return user
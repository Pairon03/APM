# api/views/produto_view.py
from rest_framework import viewsets
from rest_framework.permissions import AllowAny
from api.models import Produto
from api.serializers import ProdutoSerializer

class ProdutoViewSet(viewsets.ModelViewSet):
    # Endpoint para o Cardápio (GET)
    queryset = Produto.objects.all()
    serializer_class = ProdutoSerializer
    permission_classes = [AllowAny]
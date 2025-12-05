from django.urls import path, include
from rest_framework.routers import DefaultRouter

# Importar as classes ViewSet diretamente do arquivo onde elas estão definidas:
from .views.usuario_view import UsuarioViewSet
from .views.produto_view import ProdutoViewSet

router = DefaultRouter()
router.register(r'usuarios', UsuarioViewSet)
router.register(r'cardapio', ProdutoViewSet)

urlpatterns = [
    path('', include(router.urls)),
]
# mange_eats_backend/api/admin.py
from django.contrib import admin
from .models import Produto

@admin.register(Produto)
class ProdutoAdmin(admin.ModelAdmin):
    list_display = ('nome', 'preco', 'categoria')
    list_filter = ('categoria',)
    search_fields = ('nome',)

# Para garantir que o Django encontre o modelo, você precisa garantir que a importação funciona.
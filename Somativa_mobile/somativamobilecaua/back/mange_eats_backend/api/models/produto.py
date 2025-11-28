# api/models/produto.py
from django.db import models

class Produto(models.Model):
    nome = models.CharField(max_length=100)
    descricao = models.TextField()
    preco = models.DecimalField(max_digits=5, decimal_places=2)
    categoria = models.CharField(max_length=50, choices=[
        ('pizza', 'Pizza'),
        ('lanche', 'Lanche'),
    ])

    def __str__(self):
        return self.nome
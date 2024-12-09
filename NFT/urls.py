

from django.contrib import admin
from django.urls import path
from NFT import views
from .views import index, interact

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', views.index, name='index'),
    #path('create_drug/', views.create_drug, name='create_drug'),
    #path('change_owner/', views.change_owner, name='change_owner'),
    path('interact/', views.interact, name='interact'),
    
]


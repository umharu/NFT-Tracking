from django.apps import AppConfig
from web3 import Web3
import json
import os

class NftConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'nft'

class BlockchainConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'nft'

    
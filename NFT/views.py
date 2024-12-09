from django.shortcuts import render
from django.http import JsonResponse
from web3 import Web3
from django.conf import settings


def index(request):
 
    return render(request, 'index.html')


def interact(request):
    w3 = Web3(Web3.HTTPProvider(settings.WEB3_PROVIDER))
    
    contract = w3.eth.contract(
        address=settings.CONTRACT_ADDRESS,
        abi=settings.CONTRACT_ABI
    )

    try:
        owner_history = contract.functions.getOwnerHistory().call()
    except Exception as e:
        owner_history = []
        print(f"Error al leer getOwnerHistory: {e}")

    context = {
        'contract_address': settings.CONTRACT_ADDRESS,
        'owner_history': owner_history,
    }
    return render(request, 'interact.html', context)



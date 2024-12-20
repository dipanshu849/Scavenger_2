from firebase_functions import https_fn
import firebase_admin
from firebase_admin import firestore

firebase_admin.initialize_app()

@https_fn.on_request
def reset_picked_up_status(request):
    db = firestore.client()
    users_ref = db.collection('users')
    docs = users_ref.stream()
    
    for doc in docs:
        users_ref.document(doc.id).update({'pickedUp': False})
    
    return "Picked up status reset"

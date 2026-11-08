from modules_py_api.api import api
from mangum import Mangum

handler = Mangum(api)

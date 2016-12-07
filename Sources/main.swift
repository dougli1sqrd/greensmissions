import Foundation
import Kitura
import HeliumLogger
import LoggerAPI
import SwiftyJSON

setbuf(stdout, nil)

Log.logger = HeliumLogger()

Log.info("Starting server")
let s = MemoryCompanyEmissionsService()
let r = EmissionsRouter(service: s)
let router = r.makeRouter()

Kitura.addHTTPServer(onPort:9999, with: router)
Kitura.run()

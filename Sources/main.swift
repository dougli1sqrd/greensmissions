import Foundation
import Kitura
import HeliumLogger
import SwiftyJSON

HeliumLogger.use()
let router = Router()

router.get("/") {
    request, response, _ in

    let name = request.queryParameters["name"] ?? "World"
    try response.send("Hello, \(name)").end()
}

router.get("/:name") {
    request, response, next in

    let name = request.parameters["name"] ?? "No Name"
    response.send("Your name is \(name)\n")
    response.send("coming from \(request.hostname)")
    try response.end()
}

router.get("/data/:id(\\d+)") {
    request, response, next in

    let id = request.parameters["id"] ?? "0"
    let responseContent: JSON = [
        "id": id,
        "content": "The content with id \(id)"
    ]
    response.send(json: responseContent)
    try response.end()
}

Kitura.addHTTPServer(onPort:9999, with: router)

Kitura.run()

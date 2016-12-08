import Kitura
import HeliumLogger
import SwiftyJSON
import HeliumLogger
import LoggerAPI

typealias NextType = () -> Void

class EmissionsRouter<S: CompanyEmissionsService> {

    var service: S

    init(service: S) {
        self.service = service
    }

    func makeRouter() -> Router {
        let router = Router()

        router.route(NewCompanyRoute(service))
        router.route(ViewCompany(service))
        return router
    }
}

protocol Route {

    var method: RouterMethod { get }

    var path: String { get }

    func handler(request: RouterRequest, response: RouterResponse, next: NextType)

    // static func build() -> Route {
    //
    // }
}

struct NewCompanyRoute<S: CompanyEmissionsService>: Route {

    var service: S
    let method: RouterMethod = .post
    let path = "/companies"

    init(_ service: S) {
        self.service = service
    }

    func handler(request: RouterRequest, response: RouterResponse, next: NextType) {
        Log.info("handling \(method): \(path)")
        if let name = request.queryParameters["name"] {
            Log.info("Name found: \(name)")
            let company = service.makeCompany(name: name)
            response.send(json: company.to())
        } else {
            response.send(json: ["name": "none"])
        }
        next()
    }
}

struct ViewCompany<S: CompanyEmissionsService>: Route {

    var service: S
    let method: RouterMethod = .get
    let path = "/companies/:companyName"

    init(_ service: S) {
        self.service = service
    }

    func handler(request: RouterRequest, response: RouterResponse, next: NextType) {
        Log.info("handling \(method): \(path)")
        let companyParam = request.parameters["companyName"] ?? "none" //should 404?

        if let company = service.viewEmissionsFor(company: companyParam) {
            response.send(json: company.to())
        } else {
            response.status(.notFound)
        }
        next()
    }
}

extension Router {

    func route(_ route: Route) {
        self.route(route.method, route.path, handler: route.handler)
    }

    func route(_ method: RouterMethod, _ path: String, handler: @escaping RouterHandler) {
        switch method {
        case .post:
            self.post(path, handler: handler)
        case .put:
            self.put(path, handler: handler)
        case .get:
            self.get(path, handler: handler)
        case .delete:
            self.delete(path, handler: handler)
        default:
            self.all(path, handler: handler)
        }
    }
}
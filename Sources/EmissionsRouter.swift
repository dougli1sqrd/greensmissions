import Kitura
import KituraNet
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
            switch service.makeCompany(name: name) {
            case let .Ok(companyEmissions):
                response.send(json: companyEmissions.to())
            case let.Err(serviceError):
                let err = HTTPError.buildFrom(error: serviceError)
                response.status(err.httpStatus).send(json: err.to())
            }
        } else {
            let problem = "Query parameter in the form of \'?name=SomeCompanyName\' on the URL is requried to create a new company."
            let badQuery = HTTPError(status: .badRequest, problem: problem)
            response.send(json: badQuery.to())
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

        switch service.viewEmissionsFor(company: companyParam) {
        case let .Ok(companyEmissions):
            response.send(json: companyEmissions.to())
        case let .Err(serviceError):
            let err = HTTPError.buildFrom(error: serviceError)
            response.status(err.httpStatus).send(json: err.to())
        }

        next()
    }
}

extension HTTPError {
    static func buildFrom(error: ServiceError) -> HTTPError {
        switch error {
        case let .noSuchCompany(askedFor):
            return HTTPError(status: .notFound, problem: "The company \'\(askedFor)\' does not exist")

        case let .companyAlreadyExists(askedFor):
            return HTTPError(status: .badRequest, problem: "The company \'\(askedFor)\' already exists, and cannot be created")
        }
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

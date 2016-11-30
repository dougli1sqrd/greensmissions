import Kitura
import HeliumLogger
import SwiftyJSON
import api

typealias NextType = () -> Void

class EmissionsRouter<S: CompanyEmissionsService> {

    var service: S

    var router = Router()

    init(service: S) {
        self.service = service
    }
}

protocol Route {

    var method: RouterMethod { get }

    var path: String { get }

    func handler(request: RouterRequest, response: RouterResponse, next: NextType)
}

struct NewCompanyRoute<S: CompanyEmissionsService>: Route {

    var service: S
    let method: RouterMethod = .post
    let path = "/companies"

    func handler(request: RouterRequest, response: RouterResponse, next: NextType) {

    }

}

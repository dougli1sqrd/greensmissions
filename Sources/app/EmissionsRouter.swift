import Kitura
import HeliumLogger
import SwiftyJSON

class EmissionsRouter<S: CompanyEmissionsService> {

    var service: S

    var router = Router()

    init(service: S) {
        self.service = service
    }
}

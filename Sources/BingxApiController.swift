import Foundation

public class BingxApiController {
    private let baseApiUrl = "https://open-api.bingx.com"
    private let baseApiController: BaseApiController

    init () {
        self.baseApiController = BaseApiController(baseUrl: baseApiUrl)
    }
    
}

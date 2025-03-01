import Foundation

struct BingxApiController {
    private let apiKey: String
    private let apiSecret: String

    init () {
        apiKey = ProcessInfo.processInfo.environment["BINGX_API_KEY"] ?? ""
        apiSecret = ProcessInfo.processInfo.environment["BINGX_API_SECRET"] ?? ""
    }
}

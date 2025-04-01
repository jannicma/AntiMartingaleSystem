import Foundation

public actor BingxApiController {
    private let baseApiUrl = "https://open-api.bingx.com"
    private let baseApiController: BaseApiController
    
    init () {
        self.baseApiController = BaseApiController(baseUrl: baseApiUrl)
    }
    
    public func getKline(symbol: String, interval: String, startTime: Int, limit: Int = 1000) async throws -> [Candle] {
        let endpoint = "/openApi/swap/v3/quote/klines"
        let params: [String: String] = [
            "symbol": symbol,
            "interval": interval,
            "startTime": String(startTime),
            "limit": String(limit),
        ]

        let apiResponse = try await baseApiController.sendRequest(endpoint: endpoint, method: "GET", parameters: params, isPrivate: false)
        let decoder = JSONDecoder()
        let response = try decoder.decode(KlineResponse.self, from: apiResponse)
        if response.code == 0 {
            if let stringCandles = response.data {
                let candles: [Candle] = stringCandles.map { Candle(stringCandle: $0) }
                return candles
            } else {
                throw NSError(domain: "API Error", code: 0, userInfo: ["message": "Data is missing in response"])
            }
        } else {
            let errorMessage = response.msg ?? "Unknown error"
            throw NSError(domain: "API Error", code: response.code, userInfo: ["message": errorMessage])
        }

        
    }
}

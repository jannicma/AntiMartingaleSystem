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
    
    public func getTrades(for symbol: String) async throws -> String {
        let endpoint = "/openApi/swap/v2/user/positions"
        let params: [String: String] = [
            "symbol": symbol,
        ]
        
        let apiResponse = try await baseApiController.sendRequest(endpoint: endpoint, method: "GET", parameters: params, isPrivate: true)
        let decoder = JSONDecoder()
        // please parse the object into a trade model.
        return ""
    }
}


// response from getTrades:
/*
 
 (lldb) po try! JSONSerialization.jsonObject(with: apiResponse, options: [])
 ▿ 3 elements
   ▿ 0 : 2 elements
     - key : msg
     - value :
   ▿ 1 : 2 elements
     - key : data
     ▿ value : 1 element
       ▿ 0 : 22 elements
         ▿ 0 : 2 elements
           - key : riskRate
           - value : 0.0226
         ▿ 1 : 2 elements
           - key : initialMargin
           - value : 3.3971
         ▿ 2 : 2 elements
           - key : positionSide
           - value : LONG
         ▿ 3 : 2 elements
           - key : margin
           - value : 3.3793
         ▿ 4 : 2 elements
           - key : leverage
           - value : 5
         ▿ 5 : 2 elements
           - key : availableAmt
           - value : 0.0002
         ▿ 6 : 2 elements
           - key : maxMarginReduction
           - value : 0.0000
         ▿ 7 : 2 elements
           - key : currency
           - value : USDT
         ▿ 8 : 2 elements
           - key : updateTime
           - value : 1743523201876
         ▿ 9 : 2 elements
           - key : avgPrice
           - value : 84927.6
         ▿ 10 : 2 elements
           - key : positionValue
           - value : 17.0
         ▿ 11 : 2 elements
           - key : positionAmt
           - value : 0.0002
         ▿ 12 : 2 elements
           - key : isolated
           - value : 1
         ▿ 13 : 2 elements
           - key : pnlRatio
           - value : 0.0058
         ▿ 14 : 2 elements
           - key : liquidationPrice
           - value : 68438.8
         ▿ 15 : 2 elements
           - key : symbol
           - value : BTC-USDT
         ▿ 16 : 2 elements
           - key : realisedProfit
           - value : -0.0462
         ▿ 17 : 2 elements
           - key : unrealizedProfit
           - value : 0.0200
         ▿ 18 : 2 elements
           - key : onlyOnePosition
           - value : 0
         ▿ 19 : 2 elements
           - key : positionId
           - value : 1898353763909050368
         ▿ 20 : 2 elements
           - key : markPrice
           - value : 85027.5
         ▿ 21 : 2 elements
           - key : createTime
           - value : 1741437781680
   ▿ 2 : 2 elements
     - key : code
     - value : 0
 
 */

import Foundation


actor MartingaleActor {
    private var bingxApi: BingxApiController?

    public func startSystem(tradeId: String, vwapStartTime: Date) -> String {
        bingxApi = BingxApiController()
        bingxApi?.getTradeBy(symbol: "BTC-USDT")

        return "aaa"
    }
}

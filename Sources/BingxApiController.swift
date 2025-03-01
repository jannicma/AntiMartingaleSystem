import Foundation
import PythonKit

struct BingxApiController {
    private let apiKey: String
    private let apiSecret: String
    private let exchange: PythonObject

    init () {
        let venvPath = "/Users/jannicmarcon/Documents/GitHub/AntiMartingaleSystem/python_env"

        setenv("PYTHONHOME", "/opt/homebrew/opt/python@3.13/Frameworks/Python.framework/Versions/3.13", 1)
        setenv("PYTHONPATH", "\(venvPath)/lib/python3.13/site-packages", 1)
        
        PythonLibrary.useLibrary(at: "/opt/homebrew/opt/python@3.13/Frameworks/Python.framework/Versions/3.13/lib/libpython3.13.dylib")

        apiKey = ProcessInfo.processInfo.environment["BINGX_API_KEY"] ?? ""
        apiSecret = ProcessInfo.processInfo.environment["BINGX_API_SECRET"] ?? ""
        
        let ccxt = Python.import("ccxt")
        exchange = ccxt.bingx([
            "apiKey": apiKey,
            "secret": apiSecret
        ])
    }
}

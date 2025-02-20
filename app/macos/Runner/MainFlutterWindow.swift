import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let flutterViewController = FlutterViewController()
        self.contentViewController = flutterViewController
        
        configureWindowAppearance()
        configureWindowSize()
        
        RegisterGeneratedPlugins(registry: flutterViewController)
    }
    
    private func configureWindowAppearance() {
        self.isOpaque = false
        self.backgroundColor = .clear
        self.titlebarAppearsTransparent = true
        self.titleVisibility = .hidden
        self.styleMask.insert(.fullSizeContentView)
        
        self.setFrameAutosaveName("")
        UserDefaults.standard.removeObject(forKey: "NSWindow Frame " + self.frameAutosaveName)
        
        self.isRestorable = false
    }
    
    private func configureWindowSize() {
        guard let screenSize = NSScreen.main?.frame else { return }
        let windowWidth: CGFloat = 1000
        let windowHeight: CGFloat = 840
        
        let xPos = (screenSize.width - windowWidth) / 2
        let yPos = (screenSize.height - windowHeight) / 2
        
        let initialFrame = NSRect(x: xPos, y: yPos, width: windowWidth, height: windowHeight)
        self.setFrame(initialFrame, display: true)
        
        self.minSize = NSSize(width: 550, height: 550)
    }
}
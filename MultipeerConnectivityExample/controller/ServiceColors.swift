//
//  ServiceColors.swift
//  MultipeerConnectivityExample
//
//  Created by Renato Lopes on 03/10/18.
//  Copyright © 2018 Renato Lopes. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class ServiceColors: NSObject,
                     MCNearbyServiceAdvertiserDelegate,
                     MCNearbyServiceBrowserDelegate,
                     MCSessionDelegate{

    
    lazy var session : MCSession = {
        let session = MCSession(peer: self.myID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    private let typeService = "change-colors"
    
    private let myID = MCPeerID.init(displayName: UIDevice.current.name)
    
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCNearbyServiceBrowser
   
    var colorDelegate: DelegateColors?
    
    
    
    
    override init() {
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myID, discoveryInfo: nil, serviceType: typeService)
        self.serviceBrowser = MCNearbyServiceBrowser.init(peer: myID, serviceType: typeService)
        super.init()
        
        //Advertiser
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        
        //Browser
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
    }
    
    //Advertiser Delegate
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", peerID)
        invitationHandler(true, self.session)

    }
    
    
    //Browser Delegate
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "foundPeer - \(peerID)")
        NSLog("%@", "invitePeer: \(peerID)")
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", " lostPeer - \(peerID)")
        
        
    }
    
   //Session Delegate
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state.rawValue)")
        self.colorDelegate?.connectedDevicesChanged(manager: self, connectedDevices:
            session.connectedPeers.map{$0.displayName})
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
        let str = String(data: data, encoding: .utf8)!
        self.colorDelegate?.colorChanged(manager: self, colorString: str)
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    
    func sendColor(withName name: String){
        if session.connectedPeers.count > 0 {
            do{
                try self.session.send(name.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
            }
            catch let error{
                print(error.localizedDescription)
            }
        }
    }
}

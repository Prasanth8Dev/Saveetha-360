//
//  BufferTimeRouter.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 21/10/24.
//

import Foundation
import UIKit

protocol BufferTimeRouterProtocol {
    static func createBufferTime() -> UIViewController
}

class BufferTimeRouter: BufferTimeRouterProtocol {
    static func createBufferTime() -> UIViewController {
        let bufferVC: BufferTimingViewController = BufferTimingViewController.instantiate()
        let bufferPresenter = BufferTimePresenter()
        let bufferInteractor = BufferTimeInteractor()
        
        bufferVC.bPresenter = bufferPresenter
        bufferPresenter.view = bufferVC
        bufferPresenter.bufferInteractor = bufferInteractor
        
        return bufferVC
    }
}

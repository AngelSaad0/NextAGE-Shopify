//
//  UICollectionView+Extension.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/3/24.
//

import UIKit

import UIKit

extension UICollectionView {

    func applyFadeInAnimation() {
        let visibleCells = self.visibleCells
        for (index, cell) in visibleCells.enumerated() {
            cell.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0.1 * Double(index), options: [], animations: {
                cell.alpha = 1
            })
        }
    }

    func applySlideInAnimation() {
        let visibleCells = self.visibleCells
        let collectionViewWidth = self.bounds.width

        for (index, cell) in visibleCells.enumerated() {
            cell.transform = CGAffineTransform(translationX: collectionViewWidth, y: 0)
            UIView.animate(withDuration: 0.1, delay: 0.1 * Double(index), options: [], animations: {
                cell.transform = .identity
            })
        }
    }

    func applyScaleAnimation() {
        let visibleCells = self.visibleCells
        for (index, cell) in visibleCells.enumerated() {
            cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            UIView.animate(withDuration: 0.5, delay: 0.1 * Double(index), options: [], animations: {
                cell.transform = .identity
            })
        }
    }
    func applyEaseInOutAnimation() {

           for (index, cell) in visibleCells.enumerated() {
               cell.alpha = 0
               cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

               let delay = 0.1 * Double(index)

               UIView.animate(withDuration: 0.1, delay: delay, options: [.curveEaseInOut], animations: {
                   cell.alpha = 1
                   cell.transform = .identity
               }, completion: nil)
           }
       }

    func applyRotationAnimation() {
        let visibleCells = self.visibleCells
        for (index, cell) in visibleCells.enumerated() {
            cell.transform = CGAffineTransform(rotationAngle: .pi / 6)
            UIView.animate(withDuration: 0.5, delay: 0.1 * Double(index), options: [], animations: {
                cell.transform = .identity
            })
        }
    }

    func applyBounceAnimation() {
        let visibleCells = self.visibleCells
        for (index, cell) in visibleCells.enumerated() {
            cell.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            UIView.animate(withDuration: 0.3, delay: 0.1 * Double(index), options: [.curveEaseOut], animations: {
                cell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }) { _ in
                UIView.animate(withDuration: 0.3, animations: {
                    cell.transform = .identity
                })
            }
        }
    }
}

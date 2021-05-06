//
//  StrechyHeaderLayout.swift
//  Koting
//
//  Created by 임정우 on 2021/05/06.
//

import UIKit

class StrechyHeaderLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        
        layoutAttributes?.forEach { attributes in
            
            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader && attributes.indexPath.section == 0 {
                
                guard let collectionView = collectionView else { return }
                
                let contentOffsectY = collectionView.contentOffset.y
                
                // 위로 올릴때
                if contentOffsectY > 0 {
                    return
                }
                
                let width = collectionView.frame.width
                
//                let height = attributes.frame.height - contentOffsectY
                // For Header
                attributes.frame = CGRect(x: 0, y: contentOffsectY, width: width, height: attributes.frame.height)
            }
        }
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

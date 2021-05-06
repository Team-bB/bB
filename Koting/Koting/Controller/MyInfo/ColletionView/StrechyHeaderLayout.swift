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
            
            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader {
                
                guard let collectionView = collectionView else { return }
                
//                let contentOffsectY = collectionView.contentOffset.y
//                print(contentOffsectY)
                
                let width = collectionView.frame.width
                attributes.frame = CGRect(x: 0, y: 0, width: width, height: attributes.frame.height)
            }
        }
        return layoutAttributes
    }
}

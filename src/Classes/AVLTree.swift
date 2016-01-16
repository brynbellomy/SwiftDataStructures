//
//  AVLTree.swift
//  SwiftDataStructures
//
//  Created by bryn austin bellomy on 2015 Feb 9.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation


public class AVLTree <T: Comparable>
{
    private var value: T? = nil
    private var left: AVLTree? = nil
    private var right: AVLTree? = nil
    
    public init() {
    }
    
    // add item based on its value
    public func addNode(val: T)
    {
        // check for the head node
        if (value == nil) {
            value = val
            return
        }
        
        
        // check the left side of the tree
        if (val < value)
        {
            if (left != nil) {
                left!.addNode(val)
            }
            else {
                
                // create a new left node
                let leftChild: AVLTree = AVLTree()
                leftChild.value = val
                left = leftChild
            }
            
        }
        
        // check the left side of the tree
        if (val > value)
        {
            if (right != nil) {
                right!.addNode(val)
            }
            else
            {
                // create a new right node
                let rightChild: AVLTree = AVLTree()
                rightChild.value = val
                right = rightChild
            }
        }
    }
}


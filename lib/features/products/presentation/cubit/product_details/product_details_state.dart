import 'package:flutter/material.dart';

class ProductDetailsState {
  final String? selectedSize;
  final Color selectedColor;
  final int quantity;

  const ProductDetailsState({
    this.selectedSize,
    this.selectedColor = Colors.black,
    this.quantity = 1,
  });

  ProductDetailsState copyWith({
    String? selectedSize,
    bool clearSelectedSize = false,
    Color? selectedColor,
    int? quantity,
  }) {
    return ProductDetailsState(
      selectedSize: clearSelectedSize
          ? null
          : selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
      quantity: quantity ?? this.quantity,
    );
  }
}
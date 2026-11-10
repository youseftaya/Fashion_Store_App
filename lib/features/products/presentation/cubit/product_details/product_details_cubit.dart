import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit()
      : super(const ProductDetailsState());

  void selectSize(String size) {
    emit(state.copyWith(selectedSize: size));
  }

  void selectColor(Color color) {
    emit(state.copyWith(selectedColor: color));
  }

  void increaseQuantity() {
    emit(state.copyWith(quantity: state.quantity + 1));
  }

  void decreaseQuantity() {
    if (state.quantity <= 1) return;

    emit(state.copyWith(quantity: state.quantity - 1));
  }

  void resetSelections() {
    emit(const ProductDetailsState());
  }
}
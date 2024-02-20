import 'package:user_mobile_app/features/faqs/data/model/faq.dart';

abstract class FAQsState {}

class FAQsInitial extends FAQsState {}

class FAQsLoading extends FAQsState {}

class FAQsLoaded extends FAQsState {
  final List<FaQs> faqs;

  FAQsLoaded({required this.faqs});
}

class FAQsError extends FAQsState {
  final String message;

  FAQsError({required this.message});
}

class TokenExpired extends FAQsState {}
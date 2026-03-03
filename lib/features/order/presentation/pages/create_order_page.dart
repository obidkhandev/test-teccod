import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_teccod/core/api/dio_client.dart';
import 'package:test_teccod/core/utils/enums.dart';
import 'package:test_teccod/features/order/data/datasources/order_datasource.dart';
import 'package:test_teccod/features/order/data/models/order_model.dart';
import 'package:test_teccod/features/order/data/repositories/order_repository_impl.dart';
import 'package:test_teccod/features/order/domain/usecases/create_order_usecase.dart';
import 'package:test_teccod/features/order/presentation/cubit/order_controller.dart';
import 'package:test_teccod/features/order/presentation/cubit/order_state.dart';

class CreateOrderPage extends StatelessWidget {
  const CreateOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderController(
        CreateOrderUseCase(
          OrderRepositoryImpl(
            OrderDatasourceImpl(DioClient()),
          ),
        ),
      ),
      child: const _CreateOrderView(),
    );
  }
}

class _CreateOrderView extends StatefulWidget {
  const _CreateOrderView();

  @override
  State<_CreateOrderView> createState() => _CreateOrderViewState();
}

class _CreateOrderViewState extends State<_CreateOrderView> {
  final _userIdController = TextEditingController();
  final _serviceIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _userIdController.dispose();
    _serviceIdController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<OrderController>().submitOrder(
          userId: int.parse(_userIdController.text.trim()),
          serviceId: int.parse(_serviceIdController.text.trim()),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Создать заказ')),
      body: BlocBuilder<OrderController, OrderState>(
        builder: (context, state) {
          final isLoading = state.status == OrderStatus.loading;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _userIdController,
                    enabled: !isLoading,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'User ID',
                      hintText: 'Введите userId',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Введите userId';
                      }
                      if (int.tryParse(value.trim()) == null) {
                        return 'Должно быть целым числом';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _serviceIdController,
                    enabled: !isLoading,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Service ID',
                      hintText: 'Введите serviceId',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Введите serviceId';
                      }
                      if (int.tryParse(value.trim()) == null) {
                        return 'Должно быть целым числом';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  if (state.status == OrderStatus.success && state.order != null) ...[
                    _SuccessCard(order: state.order!),
                    const SizedBox(height: 24),
                  ],
                  if (state.status == OrderStatus.error && state.errorMessage != null) ...[
                    _ErrorText(message: state.errorMessage!),
                    const SizedBox(height: 16),
                  ],
                  _SubmitButton(
                    isLoading: isLoading,
                    onPressed: isLoading ? null : () => _submit(context),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const _SubmitButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : const Text('Создать заказ'),
    );
  }
}

class _ErrorText extends StatelessWidget {
  final String message;

  const _ErrorText({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Text(
        message,
        style: TextStyle(color: Colors.red.shade700),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _SuccessCard extends StatelessWidget {
  final OrderModel order;

  const _SuccessCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Заказ создан!', style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green.shade800,
            fontSize: 16,
          )),
          const SizedBox(height: 8),
          Text('ID заказа: ${order.orderId}'),
          Text('Статус: ${order.status}'),
          if (order.paymentUrl != null)
            Text('Ссылка оплаты: ${order.paymentUrl}'),
        ],
      ),
    );
  }
}

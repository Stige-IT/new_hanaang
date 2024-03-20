part of "../pre_order.dart";

class QuantityWidget extends ConsumerStatefulWidget {
  final PreOrderUser data;
  final TextEditingController controller;

  const QuantityWidget({
    super.key,
    required this.data,
    required this.controller,
  });

  @override
  ConsumerState createState() => _QuantityWidgetState();
}

class _QuantityWidgetState extends ConsumerState<QuantityWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Jumlah pengambilan : "),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: widget.controller,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        suffix: Text('/ ${widget.data.quantity} Cup'),
                      ),
                      validator: (value) {
                        if (int.parse(value!) > (widget.data.quantity!)) {
                          return "Melebihi Total Pesanan";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          if (int.parse(value) <= (widget.data.quantity!)) {
                            ref.watch(quantityNotifier.notifier).state =
                                int.parse(value);
                          } else {
                            widget.controller.text =
                                widget.data.quantity!.toString();
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () => _handleQuantity(false),
              icon: const Icon(Icons.remove_circle),
            ),
            IconButton(
              onPressed: () => _handleQuantity(true),
              icon: const Icon(Icons.add_circle),
            )
          ],
        ),
      ],
    );
  }

  _handleQuantity(bool isIsncrement) {
    int quantity = int.parse(widget.controller.text);
    if (isIsncrement &&
        int.parse(widget.controller.text) < (widget.data.quantity!)) {
      ref.watch(quantityNotifier.notifier).state++;
      quantity++;
    } else if (!isIsncrement && int.parse(widget.controller.text) > 0) {
      ref.watch(quantityNotifier.notifier).state--;
      quantity--;
    }
    widget.controller.text = quantity.toString();
  }
}

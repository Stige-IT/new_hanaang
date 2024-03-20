part of "../../reciep.dart";

class CardRecipt extends StatelessWidget {
  const CardRecipt({
    super.key,
    required this.recipt,
    this.onTap,
    this.selected = false,
  });
  final void Function()? onTap;
  final bool? selected;
  final Recipt? recipt;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        tileColor: selected! ? Colors.orange[50] : null,
        onTap: onTap ??
            () => nextPage(
                  context,
                  "${AppRoutes.sa}/recipt/detail",
                  argument: recipt!.id,
                ),
        title: Text(
          "${recipt?.productEstimation ?? "0"} Cup",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        subtitle: Text(
          (recipt?.createdAt ?? "").timeFormat(),
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Text(
          "Dibuat oleh:\n${recipt?.createdBy?.name ?? "-"}",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

// ✅ Botón completamente personalizable
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isActive;
  final double paddingVertical;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isActive = false, // ✅ Controla si el botón está activo
    this.paddingVertical = 12, // ✅ Permite cambiar el tamaño vertical
    this.borderRadius = 6, // ✅ Permite modificar el radio de los bordes
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isActive ? onPressed : null, // ✅ Se activa solo si `isActive` es `true`
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? const Color(0xFF826B56) : Colors.grey, // ✅ Marrón si hay cambios, gris si no
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: paddingVertical), // ✅ Permite modificar el tamaño
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)), // ✅ Bordes redondeados
        ),
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

// ✅ Botón básico, solo permite modificar fondo y texto
class SimpleButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;

  const SimpleButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = Colors.grey, // ✅ Color por defecto gris
    this.textColor = Colors.white, // ✅ Texto por defecto blanco
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor, // ✅ Color personalizado del fondo
          foregroundColor: textColor, // ✅ Color personalizado del texto
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)), // ✅ Bordes redondeados
        ),
        child: Text(label, style: TextStyle(color: textColor)),
      ),
    );
  }
}

// ✅ Botón con icono y texto, con bordes y diseño personalizable
class IconButtonCustom extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;

  const IconButtonCustom({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.backgroundColor = Colors.white, // ✅ Fondo blanco por defecto
    this.textColor = Colors.black, // ✅ Texto negro por defecto
    this.borderRadius = 8, // ✅ Bordes redondeados suaves
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: textColor, size: 24), // ✅ Icono dentro del botón
        label: Text(label, style: TextStyle(color: textColor)),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor, // ✅ Personalización del fondo
          foregroundColor: textColor, // ✅ Personalización del color del texto
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
          side: const BorderSide(color: Color.fromARGB(255, 200, 200, 200), width: 2), // ✅ Borde gris claro
        ),
      ),
    );
  }
}
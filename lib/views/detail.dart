import 'package:flutter/material.dart';
import 'package:kuis_mobile/models/data.dart';

class DetailPage extends StatefulWidget {
  final Product product;

  const DetailPage({super.key, required this.product});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late bool _isWishlisted;

  @override
  void initState() {
    super.initState();
    _isWishlisted = isProductWishlisted(widget.product.id);
  }

  void _toggleWishlist() {
    setState(() {
      final added = toggleWishlist(widget.product.id);
      _isWishlisted = added;
      if (added) {
        widget.product.likeCount++;
      } else if (widget.product.likeCount > 0) {
        widget.product.likeCount--;
      }
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor:
            _isWishlisted ? Colors.red.shade700 : const Color(0xFF1A1A1A),
        content: Text(
          _isWishlisted
              ? "${widget.product.productName} ditambahkan ke wishlist!"
              : "${widget.product.productName} dihapus dari wishlist!",
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Sliver App Bar with Image
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: const Color(0xFF1A1A1A),
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: Icon(
                  _isWishlisted ? Icons.favorite : Icons.favorite_border,
                  color: _isWishlisted ? Colors.red : Colors.white,
                ),
                tooltip: _isWishlisted
                    ? "Hapus dari Wishlist"
                    : "Tambah ke Wishlist",
                onPressed: _toggleWishlist,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                "${widget.product.imageUrl}?w=600&h=600&fit=crop",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFEEEEEE),
                    child: const Icon(
                      Icons.checkroom,
                      size: 100,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
          ),

          // Product Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.product.type.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Product name
                  Text(
                    widget.product.productName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Price
                  Text(
                    widget.product.price,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Stats Row
                  Row(
                    children: [
                      _StatChip(
                        icon: Icons.favorite,
                        iconColor: _isWishlisted ? Colors.red : Colors.grey,
                        label: "${widget.product.likeCount} Suka",
                      ),
                      const SizedBox(width: 12),
                      _StatChip(
                        icon: Icons.inventory_2_outlined,
                        iconColor: widget.product.stock <= 20
                            ? Colors.orange
                            : Colors.green,
                        label: "Stok: ${widget.product.stock}",
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Divider(color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 16),



                  Row(
                    children: [
                      const Text(
                        "Jumlah Produk",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          letterSpacing: 2,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),

                      const SizedBox(width: 22,),

                      Icon(
                        Icons.remove_circle_outline_rounded,
                        size: 30,
                        color: Colors.black,
                      ),

                      const SizedBox(width: 12),
                      Text(
                         "Stok: ${widget.product.stock}",
                         style: TextStyle(
                          fontWeight: FontWeight.bold
                         ),
                      ),

                      const SizedBox(width: 12),

                      Icon(
                        Icons.add_circle_outline_rounded,
                        size: 30,
                        color: Colors.black,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Divider(color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 16),

                  // Sizes
                  const Text(
                    "UKURAN",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 2,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.product.sizes.map((size) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF1A1A1A)),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          size,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),
                  const Divider(color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 16),

                  // Description
                  const Text(
                    "DESKRIPSI",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 2,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.product.details,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.7,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color(0xFF1A1A1A),
                            content: Text(
                              "${widget.product.productName} ditambahkan ke keranjang!",
                              style: const TextStyle(color: Colors.white),
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.shopping_bag_outlined),
                      label: const Text(
                        "TAMBAH KE KERANJANG",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A1A1A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Dynamic Wishlist button with color change
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _toggleWishlist,
                      icon: Icon(
                        _isWishlisted ? Icons.favorite : Icons.favorite_border,
                        color: _isWishlisted ? Colors.white : const Color(0xFF1A1A1A),
                      ),
                      label: Text(
                        _isWishlisted
                            ? "SUDAH DI WISHLIST"
                            : "TAMBAH KE WISHLIST",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: _isWishlisted
                              ? Colors.white
                              : const Color(0xFF1A1A1A),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isWishlisted
                            ? Colors.red.shade700
                            : Colors.white,
                        foregroundColor: _isWishlisted
                            ? Colors.white
                            : const Color(0xFF1A1A1A),
                        side: BorderSide(
                          color: _isWishlisted
                              ? Colors.red.shade700
                              : const Color(0xFF1A1A1A),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: _isWishlisted ? 2 : 0,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;

  const _StatChip({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF1A1A1A),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

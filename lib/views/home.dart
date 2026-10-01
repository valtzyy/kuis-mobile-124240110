import 'package:flutter/material.dart';
import 'package:kuis_mobile/models/data.dart';
import 'package:kuis_mobile/views/detail.dart';

class HomePage extends StatefulWidget {
  final String initialCategory;
  final ValueChanged<String>? onCategoryChanged;

  const HomePage({
    super.key,
    this.initialCategory = "Semua",
    this.onCategoryChanged,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _selectedType;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialCategory;
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCategory != oldWidget.initialCategory) {
      setState(() {
        _selectedType = widget.initialCategory;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _types {
    final types = catalog.map((p) => p.type).toSet().toList();
    types.sort();
    return ["Semua", "Wishlist", ...types];
  }

  List<Product> get _filteredProducts {
    Iterable<Product> list = catalog;

    // Filter Kategori
    if (_selectedType == "Wishlist") {
      list = list.where((p) => isProductWishlisted(p.id));
    } else if (_selectedType != "Semua") {
      list = list.where((p) => p.type == _selectedType);
    }

    // Filter Search Barang
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      list = list.where((p) =>
          p.productName.toLowerCase().contains(query) ||
          p.type.toLowerCase().contains(query) ||
          p.details.toLowerCase().contains(query));
    }

    return list.toList();
  }

  void _selectCategory(String type) {
    setState(() {
      _selectedType = type;
    });
    widget.onCategoryChanged?.call(type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "UNIQLO",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 6,
            fontSize: 18,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(21),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.trim();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Cari produk UNIQLO...",
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 13),
                      prefixIcon: const Icon(Icons.search,
                          color: Color(0xFF1A1A1A), size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear,
                                  color: Colors.grey, size: 18),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _searchQuery = "";
                                });
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 11),
                    ),
                  ),
                ),
              ),

              // Filter Kategori (Horizontal)
              SizedBox(
                height: 52,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: _types.length,
                  itemBuilder: (context, index) {
                    final type = _types[index];
                    final isSelected = type == _selectedType;
                    final isWishlist = type == "Wishlist";

                    return GestureDetector(
                      onTap: () => _selectCategory(type),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isWishlist) ...[
                              Icon(
                                Icons.favorite,
                                size: 13,
                                color: isSelected
                                    ? Colors.red
                                    : Colors.white70,
                              ),
                              const SizedBox(width: 5),
                            ],
                            Text(
                              type,
                              style: TextStyle(
                                color: isSelected
                                    ? const Color(0xFF1A1A1A)
                                    : Colors.white,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 13,
                              ),
                            ),
                            if (isWishlist && wishlistProductIds.isNotEmpty) ...[
                              const SizedBox(width: 5),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.red
                                      : Colors.white.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "${wishlistProductIds.length}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: _filteredProducts.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _selectedType == "Wishlist"
                          ? Icons.favorite_border
                          : Icons.search_off,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _selectedType == "Wishlist"
                          ? "Wishlist Masih Kosong"
                          : "Produk tidak ditemukan",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _selectedType == "Wishlist"
                          ? "Tekan tombol 'TAMBAH KE WISHLIST' pada produk untuk menyimpannya di sini."
                          : _searchQuery.isNotEmpty
                              ? "Tidak ada produk yang cocok dengan '$_searchQuery'."
                              : "Coba pilih kategori pakaian yang lain.",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    if (_selectedType == "Wishlist" || _searchQuery.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedType = "Semua";
                            _searchController.clear();
                            _searchQuery = "";
                          });
                        },
                        child: const Text("Tampilkan Semua Produk"),
                      ),
                    ],
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return _ProductCard(
                  product: product,
                  onUpdate: () => setState(() {}),
                );
              },
            ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onUpdate;

  const _ProductCard({
    required this.product,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final isWishlisted = isProductWishlisted(product.id);

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(product: product),
          ),
        );
        onUpdate();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.network(
                "${product.imageUrl}?w=200&h=200&fit=crop",
                width: 100,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 110,
                    color: const Color(0xFFEEEEEE),
                    child: const Icon(
                      Icons.checkroom,
                      color: Colors.grey,
                      size: 36,
                    ),
                  );
                },
              ),
            ),

            // Product Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        product.type,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      product.productName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF1A1A1A),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.price,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                final added = toggleWishlist(product.id);
                                if (added) {
                                  product.likeCount++;
                                } else if (product.likeCount > 0) {
                                  product.likeCount--;
                                }
                                onUpdate();
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: added
                                        ? Colors.red.shade700
                                        : const Color(0xFF1A1A1A),
                                    content: Text(
                                      added
                                          ? "${product.productName} ditambahkan ke wishlist!"
                                          : "${product.productName} dihapus dari wishlist!",
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: Icon(
                                isWishlisted
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 18,
                                color: isWishlisted ? Colors.red : Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${product.likeCount}",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Stok: ${product.stock}",
                      style: TextStyle(
                        fontSize: 11,
                        color: product.stock <= 20
                            ? Colors.orange
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

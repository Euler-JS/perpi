import 'package:flutter/material.dart';
import 'package:perpi_app/screens/Favorites/favorite_screen.dart';
import 'package:provider/provider.dart';
import 'package:perpi_app/providers/cart_provider.dart';
import 'package:perpi_app/providers/favorites_provider.dart';
import 'package:perpi_app/screens/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        surfaceTintColor: secondaryColor,
        // toolbarHeight: 100,
        // elevation: 0,
        // centerTitle: true,
        // title: Text(
        //   "Perfil",
        //   style: TextStyle(
        //     fontWeight: FontWeight.w700,
        //     fontSize: 24,
        //     color: textPrimary,
        //   ),
        // ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header com informações do usuário
              _buildUserHeader(context),
              
              const SizedBox(height: 20),
              
              // Estatísticas rápidas
              _buildQuickStats(context),
              
              const SizedBox(height: 25),
              
              // Menu de opções
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Seção da Conta
                    _buildSectionTitle("Minha Conta"),
                    const SizedBox(height: 15),
                    _buildMenuCard([
                      _buildMenuItem(
                        icon: Icons.person_outline,
                        title: "Editar Perfil",
                        subtitle: "Alterar informações pessoais",
                        onTap: () => _showComingSoon(context),
                      ),
                      _buildMenuItem(
                        icon: Icons.location_on_outlined,
                        title: "Endereços",
                        subtitle: "Gerenciar endereços de entrega",
                        onTap: () => _showComingSoon(context),
                      ),
                      _buildMenuItem(
                        icon: Icons.payment_outlined,
                        title: "Métodos de Pagamento",
                        subtitle: "MPesa, Emola, Cartão",
                        onTap: () => _showComingSoon(context),
                      ),
                    ]),
                    
                    const SizedBox(height: 25),
                    
                    // Seção de Compras
                    _buildSectionTitle("Compras"),
                    const SizedBox(height: 15),
                    _buildMenuCard([
                      _buildMenuItem(
                        icon: Icons.shopping_bag_outlined,
                        title: "Meus Pedidos",
                        subtitle: "Histórico e status dos pedidos",
                        onTap: () => _showComingSoon(context),
                      ),
                      _buildMenuItem(
                        icon: Icons.favorite_border,
                        title: "Favoritos",
                        subtitle: "Produtos que você curtiu",
                        trailing: Consumer<FavoritesProvider>(
                          builder: (context, favProvider, child) {
                            return favProvider.favoritesCount > 0
                                ? Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: buttonColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${favProvider.favoritesCount}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.arrow_forward_ios, size: 16);
                          },
                        ),
                        onTap: () {
                          // Navegar para tela de favoritos
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const FavoritesScreen(),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.discount_outlined,
                        title: "Cupons",
                        subtitle: "Descontos disponíveis",
                        onTap: () => _showComingSoon(context),
                      ),
                    ]),
                    
                    const SizedBox(height: 25),
                    
                    // Seção de Configurações
                    _buildSectionTitle("Configurações"),
                    const SizedBox(height: 15),
                    _buildMenuCard([
                      _buildMenuItem(
                        icon: Icons.notifications_outlined,
                        title: "Notificações",
                        subtitle: "Gerenciar alertas e avisos",
                        onTap: () => _showNotificationSettings(context),
                      ),
                      _buildMenuItem(
                        icon: Icons.security_outlined,
                        title: "Privacidade",
                        subtitle: "Senha e dados pessoais",
                        onTap: () => _showComingSoon(context),
                      ),
                      _buildMenuItem(
                        icon: Icons.language_outlined,
                        title: "Idioma",
                        subtitle: "Português",
                        onTap: () => _showComingSoon(context),
                      ),
                    ]),
                    
                    const SizedBox(height: 25),
                    
                    // Seção de Suporte
                    _buildSectionTitle("Suporte"),
                    const SizedBox(height: 15),
                    _buildMenuCard([
                      _buildMenuItem(
                        icon: Icons.help_outline,
                        title: "Central de Ajuda",
                        subtitle: "FAQ e tutoriais",
                        onTap: () => _showComingSoon(context),
                      ),
                      _buildMenuItem(
                        icon: Icons.message_outlined,
                        title: "Falar Conosco",
                        subtitle: "Chat ou telefone",
                        onTap: () => _showContactOptions(context),
                      ),
                      _buildMenuItem(
                        icon: Icons.star_outline,
                        title: "Avaliar o App",
                        subtitle: "Sua opinião é importante",
                        onTap: () => _showComingSoon(context),
                      ),
                    ]),
                    
                    const SizedBox(height: 30),
                    
                    // Botão de Logout
                    _buildLogoutButton(context),
                    
                    const SizedBox(height: 20),
                    
                    // Versão do app
                    Text(
                      "Perpi Delivery v1.0.0",
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Container(
      height: size.height * 0.35,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xff1B4332), // Verde escuro
            const Color(0xff2D5A3D), // Verde médio
            accentColor.withOpacity(0.9),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      child: Stack(
        children: [
          // Elementos decorativos de fundo
          Positioned(
            top: -50,
            right: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            top: 80,
            left: -40,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            top: 120,
            right: 80,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: buttonColor.withOpacity(0.3),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 30,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withOpacity(0.15),
              ),
            ),
          ),
          
          // Conteúdo principal
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Header bar com título e menu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        // child: IconButton(
                        //   onPressed: () {},
                        //   icon: const Icon(
                        //     Icons.more_vert,
                        //     color: Colors.white,
                        //     size: 24,
                        //   ),
                        //   padding: EdgeInsets.zero,
                        //   constraints: const BoxConstraints(),
                        // ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Foto do usuário com design moderno
                  Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: const DecorationImage(
                              image: NetworkImage(
                                'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=300&fit=crop&crop=face',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: buttonColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: buttonColor.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Nome do usuário
                  const Text(
                    "João Silva",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Telefone
                  Text(
                    "+258 84 123 4567",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Consumer2<CartProvider, FavoritesProvider>(
      builder: (context, cartProvider, favoritesProvider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.shopping_bag_outlined,
                  title: "Pedidos",
                  value: "23",
                  color: accentColor,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.favorite_border,
                  title: "Favoritos",
                  value: "${favoritesProvider.favoritesCount}",
                  color: Colors.red.shade500,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.shopping_cart_outlined,
                  title: "No Carrinho",
                  value: "${cartProvider.itemCount}",
                  color: buttonColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: textSecondary,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Ícone
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: textPrimary,
                size: 20,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Textos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            // Trailing
            trailing ??
                Icon(
                  Icons.arrow_forward_ios,
                  color: textSecondary,
                  size: 16,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showLogoutDialog(context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.logout,
                color: Colors.red.shade600,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                "Sair da Conta",
                style: TextStyle(
                  color: Colors.red.shade600,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Em Breve",
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Esta funcionalidade estará disponível em uma próxima atualização.",
            style: TextStyle(
              color: textSecondary,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showNotificationSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool pushNotifications = true;
            bool emailNotifications = true;
            bool orderUpdates = true;
            bool promotions = false;
            
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: dividerColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  Text(
                    "Notificações",
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Configurações de notificação
                  _buildNotificationTile(
                    title: "Push Notifications",
                    subtitle: "Receber notificações no celular",
                    value: pushNotifications,
                    onChanged: (value) {
                      setState(() {
                        pushNotifications = value;
                      });
                    },
                  ),
                  
                  _buildNotificationTile(
                    title: "Email",
                    subtitle: "Receber notificações por email",
                    value: emailNotifications,
                    onChanged: (value) {
                      setState(() {
                        emailNotifications = value;
                      });
                    },
                  ),
                  
                  _buildNotificationTile(
                    title: "Status do Pedido",
                    subtitle: "Atualizações sobre seus pedidos",
                    value: orderUpdates,
                    onChanged: (value) {
                      setState(() {
                        orderUpdates = value;
                      });
                    },
                  ),
                  
                  _buildNotificationTile(
                    title: "Promoções",
                    subtitle: "Ofertas e descontos especiais",
                    value: promotions,
                    onChanged: (value) {
                      setState(() {
                        promotions = value;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNotificationTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: accentColor,
          ),
        ],
      ),
    );
  }

  void _showContactOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              const SizedBox(height: 20),
              
              Text(
                "Como deseja falar conosco?",
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Opções de contato
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildContactOption(
                    icon: Icons.chat_bubble_outline,
                    title: "Chat",
                    subtitle: "Online agora",
                    color: accentColor,
                    onTap: () {
                      Navigator.pop(context);
                      _showComingSoon(context);
                    },
                  ),
                  
                  _buildContactOption(
                    icon: Icons.phone_outlined,
                    title: "Telefone",
                    subtitle: "84 000 0000",
                    color: buttonColor,
                    onTap: () {
                      Navigator.pop(context);
                      _showComingSoon(context);
                    },
                  ),
                  
                  _buildContactOption(
                    icon: Icons.email_outlined,
                    title: "Email",
                    subtitle: "suporte@perpi.mz",
                    color: Colors.blue,
                    onTap: () {
                      Navigator.pop(context);
                      _showComingSoon(context);
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                color: textSecondary,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Sair da Conta",
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Tem certeza que deseja sair da sua conta?",
            style: TextStyle(
              color: textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancelar",
                style: TextStyle(
                  color: textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Limpar providers
                final cartProvider = Provider.of<CartProvider>(context, listen: false);
                final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
                cartProvider.clearCart();
                favoritesProvider.clearFavorites();
                
                // Mostrar confirmação
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Logout realizado com sucesso!"),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Sair"),
            ),
          ],
        );
      },
    );
  }
}
